const config = {
  fields: {
    id: {
      label: 'ID',
      value(el) {
        return el.id
      }
    },
    flags: {
      label: 'Flags',
      value({ isSummary, isModifier }) {
        const results = []
        if (isModifier) {
          results.push("?!")
        }

        if (isSummary) {
          results.push("Σ")
        }

        return results.join(" ")
      }
    },
    card: {
      label: 'Card',
      value({ max, min }) {
        return formatResourceCardinality(min, max)
      },
    },
    implementationCardinality: {
      label: 'Impl. Card',
      value(_el) {
        // placeholder
        return ''
      },
    },
    // TODO: Figure out a way to enable fields that accept both defaults to just specify the field name, and let the CLI do the rest
    short: {
      label: 'Short',
      value(el) {
        return format(el.short)
      }
    },
    definition: {
      label: 'Definition',
      value(el) {
        return format(el.definition)
      }
    },
    type: {
      label: 'Type',
      value(el) {
        return formatResourceType(el.type)
      }
    },
    binding: {
      label: "Binding",
      value(el) {
        // TODO: Refactor - feels flimsy
        if (el.binding) {
          const extensions = el.binding.extension
          const binding = extensions.find((ext) => ext.valueString).valueString
          const bindingStrength = el.binding.strength
          return `${binding}(${bindingStrength})`
        }

        return ''
      }
    }
  }
}

export function format(str) {
  if (str === undefined) {
    return ''
  }

  return str
    .replaceAll(' |', ',')
    .replaceAll('\n', '')
}

export function formatResourceCardinality(min, max) {
  return `${min}-${max}`
}

/**
 * Generic string formatting function that ensures:
 * - A string value is always returned for fields where one is expected
 * - Pipes, newlines, and other characters that will 'break' Markdown Table formatting are removed from field values
 * @param str - Resource string that needs to be formatted for use in Markdown table
 * @returns string
 */
export function formatResourceType(resourceType) {
  if (resourceType === undefined) {
    return ''
  }

  if (resourceType[0].code === "Reference" && resourceType[0].targetProfile) {
    const referenceUrl = resourceType[0].targetProfile[0]
    const lastIndex = referenceUrl.lastIndexOf('/')
    const referenceResourceName = referenceUrl.slice(Math.max(0, lastIndex + 1));
    return `Reference(${referenceResourceName})`
  }

  // TODO: Figure out how to handle multiple codes
  return resourceType[0].code
}

export default config
