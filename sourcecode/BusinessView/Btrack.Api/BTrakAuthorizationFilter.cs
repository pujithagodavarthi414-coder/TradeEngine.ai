using System;
using Hangfire.Dashboard;

namespace BTrak.Api
{
    public class BTrakAuthorizationFilter : IDashboardAuthorizationFilter
    {
        public bool Authorize(DashboardContext context)
        {
            return true;
        }
    }
}