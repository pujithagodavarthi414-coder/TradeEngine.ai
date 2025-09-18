using Btrak.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.MSMQPublisher
{
    public interface ITrackerSummaryPublisher
    {
        string InsertUserSummary(Guid? userId, string trackedDate, List<ValidationMessage> validationMessages);
    }
}
