using Microsoft.AspNet.SignalR;
using Microsoft.AspNet.SignalR.Hubs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BTrak.Api.Hubs
{
    [HubName("LookupSyncNotification")]
    public class LookupSyncNotification : Hub
    {
        public void LookupSyncSuccess()
        {
            Clients.All.addMessage("Lookup Sync is successful");
        }
    }
}