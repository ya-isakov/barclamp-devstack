define :devstack_service do

  devstack_name="devstack-#{params[:name]}"

  service devstack_name do
    if (platform?("ubuntu") && node.platform_version.to_f >= 10.04)
      restart_command "restart #{devstack_name}"
      stop_command "stop #{devstack_name}"
      start_command "start #{devstack_name}"
      status_command "status #{devstack_name} | cut -d' ' -f2 | cut -d'/' -f1 | grep start"
    end
    supports :status => true, :restart => true
    action [:enable, :start]
    subscribes :restart, resources(:template => node[:devstack][:config_file])
  end

end
