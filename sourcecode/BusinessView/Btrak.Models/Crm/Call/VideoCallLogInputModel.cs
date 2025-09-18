using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Crm.Call
{
    public class VideoCallLogInputModel : InputModelBase
    {
        public VideoCallLogInputModel() : base(InputTypeGuidConstants.VideoCallLogInputCommandTypeGuid)
        {
        }

        public Guid? VideoCallLogId { get; set; }
        public Guid? ReceiverId { get; set; }
        public string RoomName { get; set; }
        public string VideoRecordingLink { get; set;}
        public string FileName { get; set; }
        public string Extension { get; set; }
        public string Type { get; set; }
        public string CompositionSid { get; set; }
        public string RoomSid { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("VideoCallLogId = " + VideoCallLogId);
            stringBuilder.Append(", ReceiverId = " + ReceiverId);
            stringBuilder.Append(", VideoRecordingLink = " + VideoRecordingLink);
            stringBuilder.Append(", FileName = " + FileName);
            stringBuilder.Append(", Extension = " + Extension);
            stringBuilder.Append(", Type = " + Type);
            return stringBuilder.ToString();
        }
    }
}
