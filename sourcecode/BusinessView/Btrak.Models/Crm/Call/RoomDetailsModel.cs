using System;

namespace Btrak.Models.Crm.Call
{
    public class RoomDetailsModel
    {
        public Guid? Id { get; set; }
        public string Name { get; set; }
        public int ParticipantCount { get; set; }
        public int MaxParticipants { get; set; } 
        public string Status { get; set; }
        public string RoomSid { get; set; }
        public Guid? ReceiverId { get; set; }
        public Guid? CompanyId { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public string ParticipantName { get; set; }
        public string Token { get; set; }
    }
}
