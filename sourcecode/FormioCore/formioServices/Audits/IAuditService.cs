using formioModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioServices.Audits
{
    public interface IAuditService
    {
        void SaveAudit<T>(Guid featureId, T auditObject, LoggedInContext loggedInContext);
    }
}
