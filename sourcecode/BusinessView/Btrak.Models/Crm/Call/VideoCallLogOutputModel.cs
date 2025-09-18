using System;

namespace Btrak.Models.Crm.Call
{
    public class VideoCallLogOutputModel
    {
        public Guid? VideoCallLogId { get; set; }
        public Guid? ReceiverId { get; set; }
        public string VideoRecordingLink { get; set; }
        public string FileName { get; set; }
        public string Type { get; set; }
        public string Extension { get; set; }
        public string UserName { get; set; }
        public string ProfileImage { get; set; }
        public Guid? UserId { get; set; }
        public string RoomSid { get; set; }
        public string CompositionSid { get; set; }
        public Guid CompanyId { get; set; }
        public string RoomName { get; set; }
        public DateTimeOffset CreatedDateTime { get; set; }
    }
}
