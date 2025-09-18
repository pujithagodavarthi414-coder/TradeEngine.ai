using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Goals
{
    public class GoalTagUpsertInputModel : InputModelBase
    {
        public GoalTagUpsertInputModel() : base(InputTypeGuidConstants.GoalTagUpsertInputCommandTypeGuid)
        {
        }

        public Guid? GoalId { get; set; }
        public string Tags { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("GoalId = " + GoalId);
            stringBuilder.Append(", Tags = " + Tags);
            return stringBuilder.ToString();
        }
    }
}
