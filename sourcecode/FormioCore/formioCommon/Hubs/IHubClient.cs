using formioCommon.Constants;
using System.Threading.Tasks;

namespace Formio.Hubs
{
    public interface IHubClient
    {
        Task BroadCastMessage();
        Task BroadCastNotification(NotificationModel data);
        Task BroadCastNotificationToUser(string data);
    }
}
