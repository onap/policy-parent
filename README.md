Copyright 2018 AT&T Intellectual Property. All rights reserved.
Modifications Copyright (C) 2026 OpenInfra Foundation Europe. All rights reserved.
This file is licensed under the CREATIVE COMMONS ATTRIBUTION 4.0 INTERNATIONAL LICENSE
Full license text at https://creativecommons.org/licenses/by/4.0/legalcode

This source repository contains the ONAP Policy Parent repository that contains the
parent pom.xml for most of the repos under policy/ directory.

To build it using Maven 3, run: `mvn clean install`

---

# Dependency Management Overview

All dependency and plugin versions for the Policy Framework are centrally managed in
`integration/pom.xml` (this repo). Child repos (common, models, api, pap, etc.) inherit
versions from here and should never declare inline `<version>` tags for managed
dependencies.

Notable exceptions that do **not** inherit from the parent pom:

- **policy/clamp** — has its own dependency management in
  `clamp/clamp-parent/dependencies/pom.xml`. Uplifts for clamp must be performed there independently.
- **policy/opa-pdp** — written in Go, so it uses Go modules (`go.mod`) for dependency management rather than Maven.

**Note:** Dependabot is configured to apply **patch-level updates only** automatically (see .github/dependabot.yml).
Major and minor version uplifts must be performed manually using the process below.

---

# Dependency Uplift Guide

## Prerequisites

- Maven 3.6.3+, Java 21
- All policy repos cloned side-by-side
- `gita` installed (optional, but recommended for multi-repo git operations)

> All commands below assume your working directory is the aggregator root
> (the `policy/` directory containing all repo checkouts) unless otherwise noted.

## Step 1: Pull latest changes for all repos

It is recommended to pull latest master branch changes for each repo before starting dependency uplifts:
```bash
cd parent
git checkout master && git pull
cd ..
```
and similar for other repos.

As Policy Framework spans many git repos, `gita` simplifies multi-repo git operations such as branch switching, status
checking, and pushing. To set up `gita` for Policy Framework, you may set it up like:

```bash
sudo apt install gita  # Debian/Ubuntu
gita add apex-pdp api common distribution docker drools-applications drools-pdp models pap parent xacml-pdp
```

Using `gita`, you may refresh the repos using:

```bash
gita super checkout master
gita pull
gita ll
```

## Step 2: Check Available Updates

The `versions-maven-plugin` is already configured to run `display-dependency-updates`
during the `validate` phase in `integration/pom.xml`. Simply run:

```bash
mvn -f parent validate
```

For more fine-grain control, you can directly run the `display-dependency-updates` goal. To see only minor updates:
```bash
mvn -f parent versions:display-dependency-updates -DallowMajorUpdates=false
```

This prints a report of all managed dependencies with newer versions available, filtering out pre-release/snapshot 
versions automatically (via the `ruleSet` configuration in the pom). For example:

```text
[INFO] The following dependencies in Dependency Management have newer versions:
[INFO]   org.apache.commons:commons-jexl3 ...................... 3.6.2 -> 3.6.3
[INFO]   org.drools:drools-bom ................... 8.40.1.Final -> 8.44.0.Final
```

To also check plugin updates, run:

```bash
mvn -f parent versions:display-plugin-updates
```

You may wish to also run a vulnerability scanner such as Trivy to find CVEs.

## Step 3: Apply Updates in Parent

Edit `parent/integration/pom.xml` and bump the relevant `<version.xxx>` properties.

For example, to uplift Spring Boot:

```xml
<version.springboot>4.2.0</version.springboot>
```

## Step 4: Create the Aggregator POM

Because the Policy Framework is split across multiple git repos, there is no single
reactor that builds everything. You need a local aggregator pom that sits above all
the repos to run a full build in one command.

Create a `pom.xml` in the directory that contains all the repo checkouts:

```
policy/           <-- aggregator pom goes here
├── parent/
├── common/
├── models/
├── docker/
├── api/
├── pap/
├── apex-pdp/
├── distribution/
├── xacml-pdp/
├── drools-pdp/
└── drools-applications/
```

Aggregator `pom.xml`:

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
                             http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>org.onap.policy</groupId>
    <artifactId>policy-aggregator</artifactId>
    <version>1.0.0-SNAPSHOT</version>
    <packaging>pom</packaging>
    <name>Policy Aggregator</name>

    <modules>
        <module>parent</module>
        <module>common</module>
        <module>models</module>
        <module>docker</module>
        <module>api</module>
        <module>pap</module>
        <module>distribution</module>
        <module>apex-pdp</module>
        <module>xacml-pdp</module>
        <module>drools-pdp</module>
        <module>drools-applications</module>
    </modules>
</project>
```

**Note:** This pom is local-only and should not be committed to any repo.

**Note:** The order in which the modules are built is important! For example, `api` depends on `models` which depends
on `common` which depends on `parent`, while `drools-applications` depends on artifacts from `drools-pdp`, etc.

## Step 5: Build All Components

From the aggregator directory:

```bash
mvn clean install
```
This will build all components and run maven tests.
**Note:** The above can take 30 minutes to build and test all components.
**Note:** In some cases like adding a new dependency, the `mvn validate` phase would fail, as the needed parent changes are not in your local .m2 cache. In such cases, doing `mvn clean install` on parent will fix the issues.

Or to resume from a failing module:

```bash
mvn clean install -rf :failing-module-artifactId
```

## Step 6: Build Docker Images & Run CSITs

To validate that uplifted dependencies work in containerized deployments, you must build all docker images:

```bash
mvn clean install -DskipTests -Pdocker
```

This can be run from the aggregator pom, or per-repo as needed.

CSITs are stored in the `policy/docker` repo for all components (except clamp, which are stored in clamp repo).

Run the full CSIT suite to verify nothing is broken end-to-end. Create a
`run-all-csits.sh` script in the aggregator root:

```bash
#!/bin/bash
set -u
PROJECTS="api pap apex-pdp distribution xacml-pdp drools-pdp drools-applications"
cd docker
for project in $PROJECTS; do
    echo "=== Testing $project ==="
    ./csit/run-project-csit.sh --local $project
    echo
done
cd ..
```

Then run it:

```bash
chmod +x run-all-csits.sh
./run-all-csits.sh
```

If all tests are passing, the dependency updates have been successful.

## Quick Reference

| Step | Command | Where |
|------|---------|-------|
| Check updates | `mvn -f parent validate` | aggregator root |
| Edit versions | edit `parent/integration/pom.xml` | aggregator root |
| Full build | `mvn clean install` | aggregator root |
| Docker images | `mvn clean install -DskipTests -Pdocker` | aggregator root |
| CSITs | `./run-all-csits.sh` | aggregator root |
