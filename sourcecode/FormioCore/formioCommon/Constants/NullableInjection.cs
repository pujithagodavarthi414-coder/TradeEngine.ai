using Omu.ValueInjecter.Injections;
using System;
using System.Reflection;

namespace formioCommon.Constants
{
    public class NullableInjection : LoopInjection
    {
        protected override bool MatchTypes(Type source, Type target)
        {
            return (source == target
                    || source == Nullable.GetUnderlyingType(target)
                    || (Nullable.GetUnderlyingType(source) == target
                        && source != null)
                   );
        }

        protected override void SetValue(object source, object target, PropertyInfo sp, PropertyInfo tp)
        {
            var val = sp.GetValue(source);
            if (val != null)
            {
                tp.SetValue(target, val);
            }
        }
    }
}
