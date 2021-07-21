import semver
import json
import subprocess
import sys

def getTags() :
    cmd = [
        'aws',
        'ecr',
        'list-images', 
        '--region',
        'us-east-1',
        '--repository-name',
        'ecr-repo',
        "--query",
        '''imageIds[*].imageTag''',
        '--output',
        'json'
        ]
    out = subprocess.run(cmd, capture_output=True, text=True)
    if (out.stderr != '') :
        return []
    jsonOut = out.stdout;
    if (jsonOut == '') :
        return []
    return json.loads(jsonOut)

def main() :
    tags = getTags()
    if (len(tags) == 0) :
        return 128
    latest = max(
        getTags(),
         key=lambda x: semver.VersionInfo.parse(x)
    )
    print(latest)
    return 0

sys.exit(main())
