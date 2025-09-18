using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Templates
{
   public class TemplatesUpsertModel
    {
        public Guid? TemplateId { get; set; }
        public Guid? ProjectId { get; set; }
        public Guid? GoalId { get; set; }
        public string TemplateName { get; set; }
        public Guid? TemplateResponsiblePersonId { get; set; }
        public DateTimeOffset? OnBoardProcessDate { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool? IsArchived { get; set; }
    }
}
