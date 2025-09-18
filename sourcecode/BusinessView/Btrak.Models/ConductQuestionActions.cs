using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models
{
    public class ConductQuestionActions
    {
        public Guid? ConductId { get; set; }
        public Guid? ProjectId { get; set; }
        public Guid? ConductQuestionId { get; set; }
        public Guid? QuestionId { get; set; }
        public string QuestionName { get; set; }
    }
}
