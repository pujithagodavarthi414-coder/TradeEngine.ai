using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models
{
    public class QuestionModel
    {
        public List<Guid> QuestionIds { get; set; }
        public bool? IsAuditElseConduct { get; set; }
        public Guid? ParentId { get; set; }
    }
}
