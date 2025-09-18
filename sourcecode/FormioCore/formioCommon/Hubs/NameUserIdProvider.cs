using Microsoft.AspNetCore.SignalR;
using Microsoft.Identity.Web;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace formioCommon.Hubs
{
    public class NameUserIdProvider : IUserIdProvider
    {
        public string GetUserId(HubConnectionContext connection)
        {
            //for example just return the user's username
            var a = connection.User?.Identity?.Name;
            //connection.User?.FindFirst(ClaimConstants.PreferredUserName)?.Value!;
            return a;
        }
    }
}
