{
  {
    path: "applications.githook"
    remote: {
      name: "githook"
      fetch: "https://github.com/lazuscripts/githook"
    }
  }
  {
    path: "applications.users"
    migrations: {after: 1}
    remote: {
      name: "users"
      fetch: "https://github.com/lazuscripts/users"
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
    }
  }



  {
    path: "locator"
    remote: {
      name: "locator"
      fetch: "https://github.com/lazuscripts/locator"
    }
  }
  { -- only used in migrations for models no longer in use
    path: "legacy"
  }
}
