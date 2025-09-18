using formioCommon.Constants;
using formioModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioServices.Audits
{
    public class AuditService : IAuditService
    {
        //private readonly AuditRepository _auditRepository = new AuditRepository();
        public void SaveAudit<T>(Guid featureId, T auditObject, LoggedInContext loggedInContext)
        {
            string isAuditEnable = string.Empty;

            TaskWrapper.ExecuteFunctionInNewThread(() =>
            {
                try
                {
                    var auditModel = new AuditModel
                    {
                        AuditObject = auditObject,
                        FeatureId = featureId
                    };

                    LoggingManager.Info(() => "Audit addition has been requested with content " + auditObject + ", with the feature id " +
                                              featureId + " under the context " + loggedInContext);

                    //_auditRepository.SaveAudit(auditModel, loggedInContext);
                }
                catch (Exception exception)
                {
                    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SaveAudit", " AuditService", exception.Message), exception);

                }
            });
        }

    }
}
