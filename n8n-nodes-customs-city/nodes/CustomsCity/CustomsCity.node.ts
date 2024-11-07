import { INodeType, INodeTypeDescription } from 'n8n-workflow';
import { httpVerbFields, httpVerbOperations } from './CustomsCityVerbDescription';

export class CustomsCity implements INodeType {
	description: INodeTypeDescription = {
		displayName: 'CustomsCity',
		name: 'customsCity',
		icon: 'file:CustomsCity.svg',
		group: ['transform'],
		version: 1,
		subtitle: '={{$parameter["operation"] + ": " + $parameter["resource"]}}',
		description: 'Interact with CustomsCity API',
		defaults: {
			name: 'CustomsCity',
		},
		inputs: ['main'],
		outputs: ['main'],
		credentials: [
			{
				name: 'CustomsCityApi',
				required: false,
			},
		],
		requestDefaults: {
			baseURL: 'https://CustomsCity.org',
			url: '',
			headers: {
				Accept: 'application/json',
				'Content-Type': 'application/json',
			},
		},
		/**
		 * In the properties array we have two mandatory options objects required
		 *
		 * [Resource & Operation]
		 *
		 * https://docs.n8n.io/integrations/creating-nodes/code/create-first-node/#resources-and-operations
		 *
		 * In our example, the operations are separated into their own file (HTTPVerbDescription.ts)
		 * to keep this class easy to read.
		 *
		 */
		properties: [
			{
				displayName: 'Resource',
				name: 'resource',
				type: 'options',
				noDataExpression: true,
				options: [
					{
						name: 'HTTP Verb',
						value: 'httpVerb',
					},
				],
				default: 'httpVerb',
			},

			...httpVerbOperations,
			...httpVerbFields,
		],
	};
}