
using System;
using System.Text;

namespace Btrak.Models.W3rtSystem
{
    public class RoomsBasedOnSearchOutputModel
    {
        public Guid? RoomId { get; set; }
        public string RoomName { get; set; }
        public string Town { get; set; }
        public string Locality { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("RoomId = " + RoomId);
            stringBuilder.Append("RoomName = " + RoomName);
            stringBuilder.Append("Town = " + Town);
            stringBuilder.Append("Locality = " + Locality);
            return stringBuilder.ToString();
        }
    }
}
