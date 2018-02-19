{
  {
    path: "applications.users" -- there is a sub-application at this location
    migrations: {after: 1518414112} -- don't run this migration or any before it
  }
  {
    path: "utility" -- another sub-application is here
  }
}
