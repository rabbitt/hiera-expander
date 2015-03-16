=begin
    Copyright (C) 2015  Carl P. Corliss <rabbitt@gmail.com>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
=end

require 'hiera/backend'
require 'hiera/config'

class Hiera
  module Expander
    VERSION = "0.0.1"
  end

  Config[:expander] ||= {
    :expand_sources = true,
    :include_roots  = false
  }

  module Backend
    class << self
      # Constructs a list of data sources to search
      #
      # If you give it a specific hierarchy it will just use that
      # else it will use the global configured one, failing that
      # it will just look in the 'common' data source.
      #
      # An override can be supplied that will be pre-pended to the
      # hierarchy.
      #
      # The source names will be subject to variable expansion based
      # on scope
      def datasources(scope, override=nil, hierarchy=nil)
        if hierarchy
          hierarchy = [hierarchy]
        elsif Config.include?(:hierarchy)
          hierarchy = [Config[:hierarchy]].flatten
        else
          hierarchy = ["common"]
        end

        hierarchy.insert(0, override) if override

        hierarchy.flatten.map do |source|
          source = parse_string(source, scope, {}, :order_override => override)
          unless source.empty? || source =~ %r:(^/|/{2,}|/$):
            expand_source(source).each do |src|
              yield(src)
            end
          end
        end
      end

      # Expands a single data source into multiple data sources.
      #
      # For example:
      #  expand_source('env/qa1/widget-app/database')
      #
      # would result in:
      #  %w[ env/qa1/widget-app/database env/qa1/widget-app env/qa1 ]
      #
      # For sources that are single level entries (e.g., 'common')
      # the are returned as is. For multi-level entries, such as the
      # example above, the root most level (e.g., 'env') is not returned
      # as a data source as it is expected that these root levels are
      # simply for organizational purposes and not meant as a root level
      # entry.
      #
      # If you require the roots on all sources, simply set the config
      # entry 'include_roots' to true.
      def expand_source(source)
        return [source] unless Config[:expander][:expand_sources]

        root, path = source.split('/', 2)
        return [root] if path.nil? || path.empty?

        [].tap do |paths|
          path = path.split('/')
          while subpath = path.pop
            paths << File.join(root, *path, subpath)
          end
          paths << root if Config[:expander][:include_roots]
        end
      end
    end
  end
end
