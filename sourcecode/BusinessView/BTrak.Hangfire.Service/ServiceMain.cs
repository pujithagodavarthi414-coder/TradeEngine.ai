using Hangfire;

namespace BTrak.Hangfire.service
{
    internal class ServiceMain
    {
        private BackgroundJobServer _server;

        public void Run()
        {
            _server = new BackgroundJobServer();
        }
        public bool Stop()
        {
           return true;
        }

        public bool Shutdown()
        {

            return true;
        }

        public bool Pause()
        {
            return true;
        }

        public bool Continue()
        {
            return true;
        }

    }
}
