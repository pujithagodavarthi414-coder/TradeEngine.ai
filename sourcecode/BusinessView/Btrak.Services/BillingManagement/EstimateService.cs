using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.BillingManagement;
using BTrak.Common;
using System;
using System.Collections.Generic;
using Btrak.Services.Audit;
using Btrak.Services.Helpers.BillingManagement;
using Btrak.Services.Helpers;

namespace Btrak.Services.BillingManagement
{
    public class EstimateService : IEstimateService
    {

        private readonly BillingEstimateRepository _billingEstimateRepository;
        private readonly IAuditService _auditService;

        public EstimateService(BillingEstimateRepository billingEstimateRepository, IAuditService auditService)
        {
            _billingEstimateRepository = billingEstimateRepository;
            _auditService = auditService;
        }

        public Guid? UpsertEstimate(UpsertEstimateInputModel upsertEstimateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEstimate", "Estimate Service"));

            if (!EstimateValidations.ValidateUpsertEstimate(upsertEstimateInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (upsertEstimateInputModel.EstimateTasks != null)
            {
                upsertEstimateInputModel.EstimateTasksXml = Utilities.ConvertIntoListXml(upsertEstimateInputModel.EstimateTasks);
            }

            if (upsertEstimateInputModel.EstimateItems != null)
            {
                upsertEstimateInputModel.EstimateItemsXml = Utilities.ConvertIntoListXml(upsertEstimateInputModel.EstimateItems);
            }

            upsertEstimateInputModel.EstimateId = _billingEstimateRepository.UpsertEstimate(upsertEstimateInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertEstimateCommandId, upsertEstimateInputModel, loggedInContext);

            LoggingManager.Debug(upsertEstimateInputModel.EstimateId?.ToString());

            return upsertEstimateInputModel.EstimateId;
        }

        public List<EstimateOutputModel> GetEstimates(EstimateInputModel estimateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllEstimates", "Estimate Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllEstimates", "Estimate Service"));

            List<EstimateOutputModel> estimateList = _billingEstimateRepository.GetEstimates(estimateInputModel, loggedInContext, validationMessages);

            if (estimateList.Count > 0)
            {
                foreach (var estimate in estimateList)
                {
                    if (estimate.EstimateTasksXml != null)
                    {
                        estimate.EstimateTasks = Utilities.GetObjectFromXml<EstimateTasksInputModel>(estimate.EstimateTasksXml, "EstimateTasksInputModel");
                    }
                    else
                    {
                        estimate.EstimateTasks = new List<EstimateTasksInputModel>();
                    }

                    if (estimate.EstimateItemsXml != null)
                    {
                        estimate.EstimateItems = Utilities.GetObjectFromXml<EstimateItemsInputModel>(estimate.EstimateItemsXml, "EstimateItemsInputModel");
                    }
                    else
                    {
                        estimate.EstimateItems = new List<EstimateItemsInputModel>();
                    }
                }
            }

            _auditService.SaveAudit(AppCommandConstants.GetEstimateCommandId, estimateInputModel, loggedInContext);

            return estimateList;
        }

        public List<EstimateStatusModel> GetEstimateStatuses(EstimateStatusModel estimateStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEstimateStatuses", "Estimate Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEstimateStatuses", "Estimate Service"));

            List<EstimateStatusModel> estimateStatusList = _billingEstimateRepository.GetEstimateStatuses(estimateStatusModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetEstimateCommandId, estimateStatusModel, loggedInContext);

            return estimateStatusList;
        }

        public List<EstimateHistoryModel> GetEstimateHistory(EstimateHistoryModel estimateHistoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEstimateHistory", "Estimate Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEstimateHistory", "Estimate Service"));

            List<EstimateHistoryModel> estimateHistoryList = _billingEstimateRepository.GetEstimateHistory(estimateHistoryModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetEstimateCommandId, estimateHistoryModel, loggedInContext);

            return estimateHistoryList;
        }
    }
}