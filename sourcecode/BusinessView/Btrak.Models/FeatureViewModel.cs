
namespace Btrak.Models
{
    public class FeatureViewModel
    {
        public string icon
        {
            get;
            set;
        }

        public string id
        {
            get;
            set;
        }

        public state state
        {
            get;
            set;
        }

        public string text
        {
            get;
            set;
        }
    }

    public class state
    {
        public bool selected
        {
            get;
            set;
        }
    }
}