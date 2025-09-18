using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.Dashboard;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.Dashboard;
using BTrak.Common;

namespace Btrak.Services.ProcessDashboardStatus
{
	public class ProcessDashboardStatusService : IProcessDashboardStatusService
	{
		private readonly ProcessDashboardStatuRepository _processDashboardStatusRepository;
		private readonly IAuditService _auditService;

		public ProcessDashboardStatusService(ProcessDashboardStatuRepository processDashboardStatusRepository, IAuditService auditService)
		{
			_processDashboardStatusRepository = processDashboardStatusRepository;
			_auditService = auditService;
		}

		public Guid? UpsertProcessDashboardStatus(ProcessDashboardStatusUpsertInputModel processDashboardStatusUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
		{
			LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertProcessDashboardStatus", "ProcessDashboardStatus Service"));

            processDashboardStatusUpsertInputModel.ProcessDashboardStatusName = processDashboardStatusUpsertInputModel.ProcessDashboardStatusName?.Trim();
            processDashboardStatusUpsertInputModel.ProcessDashboardStatusHexaValue = processDashboardStatusUpsertInputModel.ProcessDashboardStatusHexaValue?.Trim();

			LoggingManager.Debug(processDashboardStatusUpsertInputModel.ToString());

			if (!ProcessDashboardStatusValidations.ValidateUpsertProcessDashboardStatus(processDashboardStatusUpsertInputModel, loggedInContext, validationMessages))
			{
				return null;
			}
            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                processDashboardStatusUpsertInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (processDashboardStatusUpsertInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                processDashboardStatusUpsertInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }



            processDashboardStatusUpsertInputModel.ProcessDashboardStatusId = _processDashboardStatusRepository.UpsertProcessDashboardStatus(processDashboardStatusUpsertInputModel, loggedInContext, validationMessages);

			_auditService.SaveAudit(AppCommandConstants.UpsertProcessDashboardStatusCommandId, processDashboardStatusUpsertInputModel, loggedInContext);

			LoggingManager.Debug(processDashboardStatusUpsertInputModel.ProcessDashboardStatusId?.ToString());

			return processDashboardStatusUpsertInputModel.ProcessDashboardStatusId;
		}

		public List<ProcessDashboardStatusApiReturnModel> GetAllProcessDashboardStatuses(ProcessDashboardStatusInputModel processDashboardStatusInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
		{
			LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllProcessDashboardStatuses", "Process Dashboard Status Service"));

			_auditService.SaveAudit(AppCommandConstants.GetAllProcessDashboardStatusesCommandId, processDashboardStatusInputModel, loggedInContext);

			if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
			{
				return null;
			}

			List<ProcessDashboardStatusApiReturnModel> processDashboardStatusReturnModels = _processDashboardStatusRepository.GetAllProcessDashboardStatuses(processDashboardStatusInputModel, loggedInContext, validationMessages).ToList();       
			
			return processDashboardStatusReturnModels;
		}

		public ProcessDashboardStatusApiReturnModel GetProcessDashboardStatusById(Guid? processDashboardStatusId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
		{
			LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetProcessDashboardStatusById", "Process Dashboard Status Service"));

			if (!ProcessDashboardStatusValidations.ValidateStatusById(processDashboardStatusId, loggedInContext, validationMessages))
			{
				return null;
			}

			ProcessDashboardStatusInputModel processDashboardStatusInputModel = new ProcessDashboardStatusInputModel
			{
				ProcessDashboardStatusId = processDashboardStatusId
			};

            ProcessDashboardStatusApiReturnModel processDashboardStatusReturnModel = _processDashboardStatusRepository.GetAllProcessDashboardStatuses(processDashboardStatusInputModel, loggedInContext, validationMessages).FirstOrDefault();

			if (!ProcessDashboardStatusValidations.ValidateProcessDashboardStatusFoundWithId(processDashboardStatusId, validationMessages, processDashboardStatusReturnModel))
			{
				return null;
			}

			_auditService.SaveAudit(AppCommandConstants.GetProcessDashboardStatusByIdCommandId, processDashboardStatusInputModel, loggedInContext);

            return processDashboardStatusReturnModel;
		}
	}
}