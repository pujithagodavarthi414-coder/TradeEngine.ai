using formioCommon.Hubs;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using System.Security.Claims;
using System.Collections.Generic;
using System;
using Microsoft.AspNet.SignalR.Infrastructure;
using Microsoft.AspNetCore.DataProtection.KeyManagement;

namespace Formio.Hubs
{
    //[Authorize]
    public static class UserHandler
    {
        public static Dictionary<string, HashSet<string>> _connections =
            new Dictionary<string, HashSet<string>>();
        public static int Count
        {
            get
            {
                return _connections.Count;
            }
        }
        public static IEnumerable<string> GetConnections(string key)
        {
            HashSet<string> connections;
            if (_connections.TryGetValue(key, out connections))
            {
                return connections;
            }

            return Enumerable.Empty<string>();
        }

        public static void Add(string key, string connectionId)
        {
            lock (_connections)
            {
                HashSet<string> connections;
                if (!_connections.TryGetValue(key, out connections))
                {
                    connections = new HashSet<string>();
                    _connections.Add(key, connections);
                }

                lock (connections)
                {
                    connections.Add(connectionId);
                }
            }
        }
        public static void Remove(string key, string connectionId)
        {
            lock (_connections)
            {
                HashSet<string> connections;
                if (!_connections.TryGetValue(key, out connections))
                {
                    return;
                }

                lock (connections)
                {
                    connections.Remove(connectionId);

                    if (connections.Count == 0)
                    {
                        _connections.Remove(key);
                    }
                }
            }
        }
    }
    public class LookupSyncNotification : Hub<IHubClient>
    {
        private readonly IHttpContextAccessor _httpContextAccessor;

        public LookupSyncNotification(IHttpContextAccessor httpContextAccessor)
        {
            _httpContextAccessor = httpContextAccessor;
        }
        public string GetConnectionId(string existingConId)
        {
            if(!string.IsNullOrEmpty(existingConId))
            {
                var key = _httpContextAccessor.HttpContext.User.Claims.First(x => x.Type == "Name").Value;
                UserHandler.Remove(key, existingConId);
            }
            //var a = _httpContextAccessor.HttpContext.User.FindFirst(ClaimTypes.Name);
            return Context.ConnectionId; 
        }
        public dynamic GetUser() => Context.User;
        public string GetUserIdentifier() => Context.UserIdentifier;

        public override Task OnConnectedAsync()
        {
            var key = _httpContextAccessor.HttpContext.User.Claims.First(x => x.Type == "Name").Value;
            var connectionId = Context.ConnectionId;
            UserHandler.Add(key, connectionId);
            //UserHandler._connections.Add(connectionId, key);
            return base.OnConnectedAsync();
        }
        public override Task OnDisconnectedAsync(Exception exception)
        {
            UserHandler._connections.Remove(Context.ConnectionId);
            return base.OnDisconnectedAsync(exception);
        }
        //public async Task BroadCastNotification(string message)
        //{
        //    await Clients.All.BroadCastNotificationToUser(message);
        //}

        //private readonly static ConnectionMapping<string> _connections =
        //    new ConnectionMapping<string>();

        //public void BroadCastNotification(string who, string message)
        //{
        //    string name = Context.User.Identity.Name;

        //    foreach (var connectionId in _connections.GetConnections(who))
        //    {
        //        Clients.Client(connectionId).BroadCastNotification(name,message);
        //    }
        //}

        //public void OnConnected()
        //{
        //    string name = Context.User.Identity.Name;

        //    _connections.Add(name, Context.ConnectionId);
        //}

        //public void OnDisconnected(bool stopCalled)
        //{
        //    string name = Context.User.Identity.Name;

        //    _connections.Remove(name, Context.ConnectionId);
        //}

        //public void OnReconnected()
        //{
        //    string name = Context.User.Identity.Name;

        //    if (!_connections.GetConnections(name).Contains(Context.ConnectionId))
        //    {
        //        _connections.Add(name, Context.ConnectionId);
        //    }
        //}
    }
}
