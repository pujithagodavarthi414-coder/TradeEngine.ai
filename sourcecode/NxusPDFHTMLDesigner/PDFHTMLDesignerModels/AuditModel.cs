using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PDFHTMLDesignerModels
{
    public class AuditModel
    {
        public Object AuditObject
        {
            get;
            set;
        }

        public string AuditJson => JsonConvert.SerializeObject(AuditObject);

        public bool? IsOldAudit { get; set; }

        public DateTime CreatedDateTime
        {
            get;
            set;
        }

        public Guid CreatedByUserId
        {
            get;
            set;
        }

        [DatabaseGeneratedAttribute(DatabaseGeneratedOption.Computed)]
        public Guid GuidId
        {
            get;
            set;
        }

        public Guid FeatureId { get; set; }
        public Guid CompanyGuid { get; set; }
    }
}
