using System;
using System.Collections.Generic;
using System.Web.Http;
using BusinessView.Common;
using BusinessView.Models;
using BusinessView.Services;

namespace BusinessView.Api.Controllers.Api
{
    public class FeedbackApiController : ApiController
    {
        private readonly IFeedbackService _feedbackService;
        public FeedbackApiController()
        {
            _feedbackService = new FeedbackService();
        }

        /* Feedback Form */

        [HttpGet]
        public List<FeedbackType> GetFeedbackTypes()
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Feedback Types", "FeedbackApi"));

            try
            {
                var result = _feedbackService.GetFeedbackTypes();

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Feedback Types", "FeedbackApi"));

                return result;
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get Feedback Types", "FeedbackApi", ex.Message));
                throw;
            }
        }

        [HttpPost]
        public bool SaveFeedback(Feedback model)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Save Feedback", "FeedbackApi"));

            try
            {
                var result = _feedbackService.SaveFeedback(model);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Save Feedback", "FeedbackApi"));

                return result;
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Save Feedback", "FeedbackApi", ex.Message));
                throw;
            }
        }

        /* Feedback History */

        [HttpGet]
        public List<Feedback> GetFeedbackHistory(int? userId, string fromDate, string toDate)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Feedback History", "FeedbackApi"));

            try
            {
                var result = _feedbackService.GetFeedbackHistory(userId, fromDate, toDate);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Feedback History", "FeedbackApi"));

                return result;
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get Feedback History", "FeedbackApi", ex.Message));
                throw;
            }
        }

    }
}