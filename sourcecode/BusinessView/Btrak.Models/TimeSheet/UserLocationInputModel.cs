using System.Text;
using BTrak.Common;

namespace Btrak.Models.TimeSheet
{
    public class UserLocationInputModel : InputModelBase
    {
        public UserLocationInputModel() : base(InputTypeGuidConstants.UserLocationInputCommandTypeGuid)
        {
        }
       
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", Latitude = " + Latitude);
            stringBuilder.Append(", Longitude = " + Longitude);
            return stringBuilder.ToString();
        }
    }
}
