# frozen_string_literal: true

require 'spec_helper'

describe Panoptes::Endpoints::JsonApiEndpoint do
  let(:endpoint) do
    described_class.new(auth: {}, url: 'http://example.com')
  end

  describe '#paginate' do
    let(:payload) do
      {
        'subjects' =>
          [
            {
              'id' => '1',
              'metadata' => {},
              'locations' => [{
                'image/png' => 'https=>//example.com/image.png'
              }],
              'zooniverse_id' => nil,
              'external_id' => nil,
              'created_at' => '2021-11-19T13:26:59.032Z',
              'updated_at' => '2021-11-19T13:26:59.032Z',
              'href' => '/subjects/1',
              'links' => {
                'project' => '1',
                'collections' => [],
                'subject_sets' => ['1']
              }
            }
          ],
        'links' => {
          'subjects.project' => {
            'href' => '/projects/{subjects.project}',
            'type' => 'projects'
          },
          'subjects.collections' => {
            'href' => '/collections?subject_id={subjects.id}',
            'type' => 'collections'
          },
          'subjects.subject_sets' => {
            'href' => '/subject_sets?subject_id={subjects.id}',
            'type' => 'subject_sets'
          }
        },
        'meta' => {
          'subjects' => {
            'page' => 1,
            'page_size' => 20,
            'count' => 1,
            'include' => [],
            'page_count' => 1,
            'previous_page' => nil,
            'next_page' => nil,
            'first_href' => '/subjects?id=1',
            'previous_href' => nil,
            'next_href' => nil,
            'last_href' => '/subjects?id=1'
          }
        }
      }
    end

    context 'with only one result page' do
      before do
        allow(endpoint).to receive(:get).and_return(payload)
      end
      let(:yield_args) { [payload, payload] }

      it 'yields data and location for first page' do
        expect { |b| endpoint.paginate('/subjects', workflow_id: 1, &b) }.to yield_successive_args(yield_args)
      end
    end

    context 'with two result pages' do
      let(:multi_page_payload) { payload.dup }
      let(:path) { '/subjects' }
      let(:query) { { workflow_id: 1 } }
      let(:next_path) { '/subjects?page=2' }
      let(:yield_args) { [[multi_page_payload, multi_page_payload], [multi_page_payload, payload]] }

      before do
        # don't pollute the original payload object instance for the test
        multi_page_payload['meta'] = payload['meta'].dup
        multi_page_payload['meta']['subjects'] = payload['meta']['subjects'].dup
        multi_page_payload['meta']['subjects']['next_href'] = next_path
        # setup the first and second page responses
        allow(endpoint).to receive(:get).with(path, query).and_return(multi_page_payload)
        allow(endpoint).to receive(:get).with(next_path, query).and_return(payload)
      end

      it 'yields data and location both pages' do
        expect { |b| endpoint.paginate(path, query, &b) }.to yield_successive_args(*yield_args)
      end
    end
  end
end
