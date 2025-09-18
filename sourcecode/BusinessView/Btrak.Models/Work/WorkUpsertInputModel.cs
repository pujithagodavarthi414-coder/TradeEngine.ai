using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Work
{
    public class WorkUpsertInputModel : InputModelBase
    {
        public WorkUpsertInputModel() : base(InputTypeGuidConstants.WorkUpsertInputCommandTypeGuid)
        {
        }

        public Guid? WorkId
        {
            get;
            set;
        }

        public string WorkJson
        {
            get;
            set;
        }

        public DateTime? Date
        {
            get;
            set;
        }

        public Guid? UserId
        {
            get;
            set;
        }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("WorkId = " + WorkId);
            stringBuilder.Append(", WorkJson = " + WorkJson);
            stringBuilder.Append(", Date = " + Date);
            stringBuilder.Append(", UserId = " + UserId);
            return stringBuilder.ToString();
        }
    }

    public class WorkJsonUpsertInputModel
    {
        public Guid? WorkTypeId
        {
            get;
            set;
        }

        public string Message
        {
            get;
            set;
        }
    }
}
