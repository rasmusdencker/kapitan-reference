local resources = import './resources.libjsonnet';
local kap = import 'lib/kap.libjsonnet';
local service_components = import './service_components.libjsonnet';
local p = kap.parameters;

local manifest_set_by_service = {
  [service_name]: resources.ServiceManifestSet(service_components[service_name])
  for service_name in std.objectFields(service_components)
};

local manifest_groups = [
  {
    ['%s-%s' % [service_name, manifest_name]]: manifest_set_by_service[service_name][manifest_name]
    for manifest_name in std.objectFields(manifest_set_by_service[service_name])
  }
  for service_name in std.objectFields(manifest_set_by_service)
];

kap.utils.mergeObjects(manifest_groups)
