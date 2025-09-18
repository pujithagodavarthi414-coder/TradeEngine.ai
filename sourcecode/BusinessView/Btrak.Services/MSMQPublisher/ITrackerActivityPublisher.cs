using Btrak.Models;
using Btrak.Models.ActivityTracker;
using System;
using System.Collections.Generic;

namespace Btrak.Services.MSMQPublisher
{
    public interface ITrackerActivityPublisher
    {
        string InsertUserActivityTime(InsertUserActivityInputModel insertUserActivityTimeInputModel, List<ValidationMessage> validationMessages, Guid? loggedInUser);
    }
}
