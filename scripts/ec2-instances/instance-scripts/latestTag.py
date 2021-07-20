import semver
tagsStr = input()
print(max(tagsStr.split("       "), key=lambda x: semver.VersionInfo.parse(x)))