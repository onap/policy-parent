Copyright 2018 AT&T Intellectual Property. All rights reserved.
Modifications Copyright (C) 2026 OpenInfra Foundation Europe. All rights reserved.
This file is licensed under the CREATIVE COMMONS ATTRIBUTION 4.0 INTERNATIONAL LICENSE
Full license text at https://creativecommons.org/licenses/by/4.0/legalcode

This source repository contains the ONAP Policy Parent repository that contains the
parent pom.xml for most of the repos under policy directory.

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

> All commands below assume your working directory is the `policy` directory containing all repos unless otherwise noted.

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

## Step 4: Build All Components

This will build all components including docker images and run maven tests:

```bash
for repo in parent common models docker api pap distribution apex-pdp xacml-pdp drools-pdp drools-applications; do
    mvn -f $repo clean install -Pdocker
done
```

Notes:
- The above can take 30 minutes to build and test all components.
- The order in which the modules are built is important! For example, `api` depends on `models` which depends
on `common` which depends on `parent`, while `drools-applications` depends on artifacts from `drools-pdp`, etc.

## Step 5: Run CSITs

CSITs are stored in the `policy/docker` repo for all components (except clamp, which has CSITs in clamp repo).

Run the CSITs for each component to verify nothing is broken end-to-end:

```bash
cd docker
for project in api pap apex-pdp distribution xacml-pdp drools-pdp drools-applications; do
    ./csit/run-project-csit.sh --local $project
done
```

If all tests are passing, the dependency updates have been successful.
