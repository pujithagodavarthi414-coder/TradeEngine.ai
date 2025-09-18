using System;

namespace Btrak.Models.Crm.Call
{
    public class ParticipantModel
    {
        public DateTime? StartTime { get; set; }
        public DateTime? DateUpdated { get; set; }
        public DateTime? DateCreated { get; set; }
        public string Identity { get; set; }
        public string AccountSid { get; set; }
        public string RoomSid { get; set; }
        public string Sid { get; set; }
        public DateTime? EndTime { get; set; }
        public int? Duration { get; set; }
    }
}
