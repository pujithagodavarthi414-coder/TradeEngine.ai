using System;

namespace Btrak.Models.Hr
{
    public class RoomTemperatureModel
    {
        public DateTime DATE { get; set; }
        public string Time { get; set; }
        public int Temperature { get; set; }
        public string TemperatureInC { get; set; }
    }
}
