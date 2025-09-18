using Btrak.Models;
using Btrak.Models.BillingManagement;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.BillingManagement
{
    public interface IEstimateService
    {
        List<EstimateOutputModel> GetEstimates(EstimateInputModel estimateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EstimateStatusModel> GetEstimateStatuses(EstimateStatusModel estimateStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EstimateHistoryModel> GetEstimateHistory(EstimateHistoryModel estimateHistoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEstimate(UpsertEstimateInputModel upsertEstimateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
