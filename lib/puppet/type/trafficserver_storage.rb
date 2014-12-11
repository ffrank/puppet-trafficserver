#   Copyright 2014 Brainsware
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

Puppet::Type.newtype(:trafficserver_storage) do

  require 'pry' ; binding.pry

  ensurable

  validate do
    # mysteriously, this does not work:
    #
    #if self[:path] !~ %r{/dev(ices)?/} && (self[:size].nil? || self[:size] == :undef)
    #  raise ArgumentError, "Invalid format: directory `#{self[:path]}' needs a <size> given #{self[:size]}"
    #elsif (self[:path] =~ %r{^/dev(ices)?/} and self[:size])
    #  raise ArgumentError, "Invalid format: device `#{self[:path]}' must not have a <size>"
    #end
    #
    #all we get here is:
    #pry(#<Puppet::Type::Trafficserver_storage>)> to_hash
    #=> {:path=>"var/trafficserver", :provider=>:storage,
    #    :owner=>"trafficserver", :group=>"trafficserver",
    #    :target=>"/etc/trafficserver/storage.config", :loglevel=>:notice}
    #
    # i.e.: we're missing everything that is not a param or a namevar will come
    # with its default value, or with else with nil.
  end

  newparam(:path, :namevar => true) do
    desc "fully qualified path to directory or device"
    newvalues(%r{^/})
  end

  newproperty(:size) do
    desc "size: only used for directories"
    newvalues(/^\d+[KMGTP]?$/)
  end

  newparam(:type) do
    desc "Whether this is raw or dir"
    newvalues(:raw, :dir)
    validate do |val|
      require 'pry' ; binding.pry
    end
  end

  newproperty(:comment) do
    desc "optional comment"
  end

  # it's hard to discover these from the system, so we won't attempt to.
  # They have to be passed.

  newparam(:owner) do
    desc "owner of device or directory"
    defaultto 'trafficserver'
  end

  newparam(:group) do
    desc "group of device or directory"
    defaultto 'trafficserver'
  end

  def generate
    require 'pry' ; binding.pry
    []
  end
end
