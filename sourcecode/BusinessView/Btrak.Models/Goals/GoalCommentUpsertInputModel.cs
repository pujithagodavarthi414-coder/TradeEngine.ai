using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Goals
{
    public class GoalCommentUpsertInputModel : SearchCriteriaInputModelBase
    {
        public GoalCommentUpsertInputModel() : base(InputTypeGuidConstants.GoalCommentUpsertInputCommandTypeGuid)
        {
        }
        public Guid GoalId { get; set; }
        public string Comment { get; set; }
        public Guid? GoalCommentid { get; set; }

    }
}