using Btrak.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using Btrak.Dapper.Dal.Repositories;
using System.Linq;
using Btrak.Models.Status;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.Status;

namespace Btrak.Services.Status
{
    public class StatusService : IStatusService
    {
        private readonly UserStoryStatuRepository _userStoryStatuRepository;
        private readonly IAuditService _auditService;

        public StatusService(UserStoryStatuRepository userStoryStatuRepository, IAuditService auditService)
        {
            _userStoryStatuRepository = userStoryStatuRepository;
            _auditService = auditService;
        }

        public Guid? UpsertStatus(UserStoryStatusUpsertInputModel userStoryStatusInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            userStoryStatusInputModel.UserStoryStatusName = userStoryStatusInputModel.UserStoryStatusName?.Trim();
            userStoryStatusInputModel.UserStoryStatusColor = userStoryStatusInputModel.UserStoryStatusColor?.Trim();

            LoggingManager.Debug(userStoryStatusInputModel.ToString());

            if (!UserStoryStatusValidations.ValidateUpsertStatus(userStoryStatusInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                userStoryStatusInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (userStoryStatusInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                userStoryStatusInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }




            Guid? statusId =  _userStoryStatuRepository.UpsertStatus(userStoryStatusInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertStatusCommandId, userStoryStatusInputModel, loggedInContext);

            LoggingManager.Debug(statusId?.ToString());

            return statusId;
        }

        public List<UserStoryStatusApiReturnModel> GetAllStatuses(UserStoryStatusInputModel userStoryStatusInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllStatuses", "Status Service"));

            _auditService.SaveAudit(AppCommandConstants.GetAllStatusesCommandId, userStoryStatusInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<UserStoryStatusApiReturnModel> userStoryStatusReturnModels = _userStoryStatuRepository.GetAllStatuses(userStoryStatusInputModel, loggedInContext, validationMessages).ToList();
            
            return userStoryStatusReturnModels;
        }

        public UserStoryStatusApiReturnModel GetStatusById(Guid? statusId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetStatusById", "Status Service"));

            if (!UserStoryStatusValidations.ValidateStatusById(statusId, loggedInContext, validationMessages))
            {
                return null;
            }

            var userStoryStatusInputModel = new UserStoryStatusInputModel
            {
                UserStoryStatusId = statusId
            };

            UserStoryStatusApiReturnModel userStoryStatusSpReturnModel = _userStoryStatuRepository.GetAllStatuses(userStoryStatusInputModel, loggedInContext, validationMessages).FirstOrDefault();

            if (!UserStoryStatusValidations.ValidateStatusFoundWithId(statusId, validationMessages, userStoryStatusSpReturnModel))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetStatusByIdCommandId, userStoryStatusInputModel, loggedInContext);

            return userStoryStatusSpReturnModel;
        }

        public List<UserstoryStatusApiTaskStatusReturnModel> GetAllTaskStatuses(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllStatuses", "Status Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<UserstoryStatusApiTaskStatusReturnModel> userStoryStatusApiTaskStatusReturnModels = _userStoryStatuRepository.GetAllTaskStatuses(loggedInContext, validationMessages).ToList();

            return userStoryStatusApiTaskStatusReturnModels;
        }
    }
}
