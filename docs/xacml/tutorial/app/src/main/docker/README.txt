docker-compose -f docker-compose.yml run --rm start_dependencies

docker-compose -f docker-compose.yml run --rm start_all


curl -X POST http://0.0.0.0:3904/events/POLICY-PDP-PAP

Should return JSON similar to this:
{"serverTimeMs":0,"count":0}


curl -k -u 'healthcheck:zb!XztG34' 'https://0.0.0.0:6969/policy/pdpx/v1/healthcheck'

Should return JSON similar to this:
{"name":"Policy Xacml PDP","url":"self","healthy":true,"code":200,"message":"alive"}


curl -k -u 'healthcheck:zb!XztG34' 'https://0.0.0.0:6767/policy/api/v1/healthcheck'
Should return JSON similar to this:
{
    "name": "Policy API",
    "url": "policy-api",
    "healthy": true,
    "code": 200,
    "message": "alive"
}

curl -k -u 'healthcheck:zb!XztG34' 'https://0.0.0.0:6868/policy/pap/v1/healthcheck'
