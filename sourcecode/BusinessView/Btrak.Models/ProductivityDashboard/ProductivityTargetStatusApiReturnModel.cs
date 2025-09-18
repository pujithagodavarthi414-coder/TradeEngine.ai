
using System.Text;

namespace Btrak.Models.ProductivityDashboard
{
    public class ProductivityTargetStatusApiReturnModel
    {
        public float? ProductivityValue { get; set; }
        public string Color { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ProductivityValue = " + ProductivityValue);
            stringBuilder.Append(", Color = " + Color);
            return stringBuilder.ToString();
        }
    }
}
