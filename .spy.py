from spy_modules.spy_config import SpyConfig
# These are some options that are avialable already into the script:

class MySpyConfig(SpyConfig):
  pass

def create_config(options):
  return MySpyConfig(options)
