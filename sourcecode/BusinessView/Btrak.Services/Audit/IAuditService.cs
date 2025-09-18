using Btrak.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using Btrak.Models.Audit;

namespace Btrak.Services.Audit
{
    public interface IAuditService
    {
        //void SaveAudit<T>(Guid featureId, T auditObject, LoggedInContext loggedInContext) where T : InputModelBase; -> Need to change the below line with this line
        void SaveAudit<T>(Guid featureId, T auditObject, LoggedInContext loggedInContext);
        List<AuditHistoryModel> SearchAuditHistory(AuditSearchCriteriaInputModel auditSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        IList<AuditJsonModel> GetHistoryDetails(Guid userId, DateTime? dateFrom, DateTime? dateTo, Guid featureId);
        IList<AuditJsonModel> GetUserStoryAudit(AuditModelFields fields);
        IList<Btrak.Models.Audit.Audit> GetAuditByBranch(AuditTimelineInputModel auditTimelineInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        IList<AuditConductTimelineOutputModel> GetAuditConductTimeline(AuditTimelineInputModel auditTimelineInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
