{
  {
    path: "applications.githook"
    remote: {
      name: "githook"
      fetch: "https://github.com/lazuscripts/githook"
      push: "git@github.com:lazuscripts/githook.git"
    }
  }
  {
    path: "applications.users"
    migrations: {after: 1}
    remote: {
      name: "users"
      fetch: "https://github.com/lazuscripts/users"
      push: "git@github.com:lazuscripts/users.git"
    }
  }
  {
    path: "applications"
  }
  {
    path: "utility"
    remote: {
      name: "utility"
      fetch: "https://github.com/lazuscripts/utility"
      push: "git@github.com:lazuscripts/utility.git"
    }
  }



  {
    path: "locator"
    remote: {
      name: "locator"
      fetch: "https://github.com/lazuscripts/locator"
      push: "git@github.com:lazuscripts/locator.git"
    }
  }
  { -- only used in migrations for models no longer in use
    path: "legacy"
  }
}
