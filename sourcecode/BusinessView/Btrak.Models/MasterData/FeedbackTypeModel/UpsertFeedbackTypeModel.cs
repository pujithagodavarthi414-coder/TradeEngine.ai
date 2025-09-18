using BTrak.Common;
using System;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace Btrak.Models.MasterData.FeedbackTypeModel
{
    public class UpsertFeedbackTypeModel : InputModelBase
    {
        public UpsertFeedbackTypeModel() : base(InputTypeGuidConstants.FeedbackTypeInputCommandTypeGuid)
        {
        }
        public Guid? FeedbackTypeId { get; set; }
        [StringLength(50)]
        public string FeedbackTypeName { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" FeedbackTypeId= " + FeedbackTypeId);
            stringBuilder.Append(" FeedbackTypeName= " + FeedbackTypeName);
            stringBuilder.Append(" IsArchived= " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}