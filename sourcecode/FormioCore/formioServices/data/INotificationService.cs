using formioModels.Data;
using formioModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioServices.data
{
    public interface INotificationService
    {
        void NotificationAlertWorkFlow(NotificationAlertModel alertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
