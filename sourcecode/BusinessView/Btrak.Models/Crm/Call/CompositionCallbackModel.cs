using System;

namespace Btrak.Models.Crm.Call
{
    public class CompositionCallbackModel
    {
        public string RoomSid { get; set; }
        public string CompositionSid { get; set; }
        public string StatusCallbackEvent { get; set; }
        public DateTime Timestamp { get; set; }
        public string AccountSid { get; set; }
        public string CompositionUri { get; set; }
        public int Duration { get; set; }
        public string MediaUri { get; set; }
        public long? Size { get; set; }
        public int? SecondsRemaining { get; set; }
        public int? PercentageDone { get; set; }
    }
}
