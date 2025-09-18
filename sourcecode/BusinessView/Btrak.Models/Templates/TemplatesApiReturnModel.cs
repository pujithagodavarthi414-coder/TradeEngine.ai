using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Templates
{
   public class TemplatesApiReturnModel
    {
        public Guid TemplateId { get; set; }
        public Guid ProjectId { get; set; }
        public string TemplateName { get; set; }
        public Guid? TemplateResponsibleUserId { get; set; }
        public string TemplateResponsiblePersonName { get; set; }
        public Guid? BoardTypeId { get; set; }
        public string BoardTypeName { get; set; }
        public Guid? WorkflowId { get; set; }
        public DateTimeOffset? OnBoardProcessDate { get; set; }
        public string TemplateResponsibleProfileImage { get; set; }
        public bool? IsBugBoard { get; set; }
        public bool? IsSuperAgileBoard { get; set; }
        public DateTimeOffset? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
    }
}
