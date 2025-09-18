using PDFHTMLDesignerModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PDFHTMLDesignerServices.Audits
{
    public interface IAuditService
    {
        void SaveAudit<T>(Guid featureId, T auditObject, LoggedInContext loggedInContext);
    }
}
