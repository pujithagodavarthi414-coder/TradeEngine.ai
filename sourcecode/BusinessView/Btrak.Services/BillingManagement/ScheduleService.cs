using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.BillingManagement;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.BillingManagement;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.BillingManagement
{
    public class ScheduleService : IScheduleService
    {
        private readonly ScheduleRepository _scheduleRepository;
        private readonly IAuditService _auditService;

        public ScheduleService(ScheduleRepository scheduleRepository, IAuditService auditService)
        {
            _scheduleRepository = scheduleRepository;
            _auditService = auditService;
        }

        public Guid? UpsertInvoiceSchedule(UpsertInvoiceScheduleInputModel upsertInvoiceScheduleInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert InvoiceSchedule", "Schedule Service"));

            upsertInvoiceScheduleInputModel.ScheduleName = upsertInvoiceScheduleInputModel.ScheduleName?.Trim();

            LoggingManager.Debug(upsertInvoiceScheduleInputModel.ToString());

            if (!ScheduleValidations.ValidateUpsertInvoiceSchedule(upsertInvoiceScheduleInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            upsertInvoiceScheduleInputModel.InvoiceScheduleId = _scheduleRepository.UpsertInvoiceSchedule(upsertInvoiceScheduleInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertInvoiceScheduleCommandId, upsertInvoiceScheduleInputModel, loggedInContext);

            LoggingManager.Debug(upsertInvoiceScheduleInputModel.InvoiceScheduleId?.ToString());

            return upsertInvoiceScheduleInputModel.InvoiceScheduleId;
        }

        public List<ScheduleOutputModel> GetInvoiceSchedules(ScheduleInputModel scheduleInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get All Invoice Schedules", "Schedule Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get All Invoice Schedules", "Schedule Service"));

            List<ScheduleOutputModel> scheduleList = _scheduleRepository.GetInvoiceSchedules(scheduleInputModel, loggedInContext, validationMessages);

            if (scheduleList.Count > 0)
            {
                return scheduleList;
            }

            _auditService.SaveAudit(AppCommandConstants.GetInvoiceSchedulesCommandId, scheduleInputModel, loggedInContext);

            return null;
        }

        public List<ScheduleTypeOutputModel> GetScheduleTypes(ScheduleTypeInputModel scheduleTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get All Scheduletypes", "Schedule Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get All Scheduletypes", "Schedule Service"));

            List<ScheduleTypeOutputModel> scheduleTypes = _scheduleRepository.GetScheduleTypes(scheduleTypeInputModel, loggedInContext, validationMessages);

            if (scheduleTypes.Count > 0)
            {
                return scheduleTypes;
            }

            _auditService.SaveAudit(AppCommandConstants.GetScheduleTypesCommandId, scheduleTypeInputModel, loggedInContext);

            return null;
        }

        public List<ScheduleSequenceOutputModel> GetScheduleSequence(ScheduleSequenceInputModel scheduleSequenceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get All Scheduletypes", "Schedule Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get All Scheduletypes", "Schedule Service"));

            List<ScheduleSequenceOutputModel> scheduleSequences = _scheduleRepository.GetScheduleSequence(scheduleSequenceInputModel, loggedInContext, validationMessages);

            if (scheduleSequences.Count > 0)
            {
                return scheduleSequences;
            }

            _auditService.SaveAudit(AppCommandConstants.GetScheduleSequenceCommandId, scheduleSequenceInputModel, loggedInContext);

            return null;
        }
    }
}