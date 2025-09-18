using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.EmailTemplates
{
    public class TemplateModel
    {
        public Guid Id { get; set; }
        public string TemplateType { get; set; }
        public Guid TemplateTypeId { get; set; }
        public string TemplateDescription { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public string CreatedDate { get; set; }
    }
}
