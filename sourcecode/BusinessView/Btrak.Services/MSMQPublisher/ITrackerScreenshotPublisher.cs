using Btrak.Models;
using Btrak.Models.ActivityTracker;
using System;
using System.Collections.Generic;

namespace Btrak.Services.MSMQPublisher
{
    public interface ITrackerScreenshotPublisher
    {
        string InsertUserActivityScreenShot(InsertUserActivityScreenShotInputModel insertUserActivityScreenShotInputModel, List<ValidationMessage> validationMessages, Guid? loggedInUser);
    }
}
